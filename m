Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1DMOcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:32:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab1DMOcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:32:47 -0400
Message-ID: <4DA5B403.2010203@redhat.com>
Date: Wed, 13 Apr 2011 10:32:35 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH 2/3] x86, MCE: Drop default decoding notifier
References: <20110413132409.GB1900@gere.osrc.amd.com> <1302701810-2471-2-git-send-email-bp@amd64.org> <4DA5ACB2.1070505@redhat.com> <20110413141829.GE1987@aftab> <4DA5B1B1.5090905@redhat.com> <20110413142648.GB2791@aftab>
In-Reply-To: <20110413142648.GB2791@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> .. right ... but we would still see nonsensical messages before the
>> panic, which will confuse the end user.  IMO, dump the messages unless
>> it's UC.  And we shouldn't print out the human readable message at all.
>>     
> I'd still leave the "mcelog ... " line though as a hint.
>
>   

:)

There are no messages -- that's part of the problem.  We're asking a
user to do something for a message that doesn't exist ...

P.

