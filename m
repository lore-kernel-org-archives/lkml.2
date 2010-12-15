Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0LOKfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:35:51 -0500
Received: from csmtp3.one.com ([91.198.169.23]:36743 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab0LOKfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:35:50 -0500
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Dec 2010 05:35:49 EST
Message-ID: <4D0897F3.7040500@bitmath.org>
Date: Wed, 15 Dec 2010 11:26:59 +0100
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Ping has touched upon this subject as well, from the pen & touch perspective.
>> Generally, some ABS axes are actually enumerations, for which we have no
>> direct abstraction. If we had a way to declare the used values for such
>> enumerations, it would resolve these and possibly other issues.

> I think that presence of pen/touch can be detected by having
> BTN_TOOL_PEN and BTN_TOOL_FINGER. However in this case the tool is
> finger, so I do not think we should introduce BTN_TOOL_ENVELOPE. Maybe
> this is another case where we should employ the proposed device flags?

Yes. Having something like INPUT_QUIRK_SEMI_MT might be enough, and we could
drop the whole MT_TOOL_ENVELOPE circus. Chase, Peter, Chris, would you be
comfortable with such a solution?

> Anyway, it looks like we have a few concerns with current
> MT_TOOL_ENVELOPE so I want to rewind my 'next' branch.

Yep. Should I also take the opportunity to sync from -rc1 instead, and fold the
cleanup patches into the appropriate places?

Thanks,
Henrik

