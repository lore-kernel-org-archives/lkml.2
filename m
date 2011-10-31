Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab1JaNoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:44:07 -0400
Received: from juliet.ironicdesign.com ([206.166.194.228]:46849 "EHLO
	juliet.ironicdesign.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687Ab1JaNoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:44:05 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Oct 2011 09:44:05 EDT
X-AnteSpam-Report: http://antespam.com/missed/e28a60844e3ad4da6f7a0ef1252f1959b99c6b603b004d4a43feb7a3672dc1f3
X-AnteSpam-From: mdorman@ironicdesign.com
X-AnteSpam-Score: -0.2
From: Michael Alan Dorman <mdorman@ironicdesign.com>
To: postmaster@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Would it be possible to turn off RFC822TABS in vger's zmailer config?
Date: Mon, 31 Oct 2011 09:34:28 -0400
Message-ID: <87ehxtuvx7.fsf@ironicdesign.com>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dave, Matti,

https://issues.apache.org/SpamAssassin/show_bug.cgi?id=6429 has the
details regarding the investigation in the SpamAssassin dev community
that suggests that vger may be the only legitimate source of email that
uses tabs in its headers---it is otherwise a very likely sign of a spam
email.

Although as you can see from the bug report's resolution, a modification
has been done to the rule that matches to try and work around this---and
thereby not unduly penalize mailing lists hosted on vger---it seems an
even better solution would be if you were to actually change the zmailer
configuration to not modify the headers of the emails passing through
it.

I don't know much about zmailer or your majordomo setup, but it seems
like this would be a simple change that could make it easier for the
many people on vger's lists who probably use SpamAssassin to keep their
inboxes clean without undue false positives.

Thanks for your time,

Mike.
<Not really a representative of the SA devs>
