Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0HOB2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 21:28:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54340 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0HOB2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 21:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=YgmjmbP6jSwFDQFj51V8J4brEHzmH7EAkNaPco3Bd4zsn/RMrHiQS+SviDoAYNMPh7
         mdQnWcrN/wSpOQlqXlQDQysg9UN3A+iIP41cVU7vTXGgP6wJZgAVHOxtsIQ4UsXkGt79
         fnMG8YfWnutbzf2y4cjvfYbSd08GmEf7hv5Nk=
From: Grant Coady <gcoady.lk@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [0/3] 2.6.27.52 stable review
Date: Sun, 15 Aug 2010 11:28:14 +1000
Organization: scattered
Message-ID: <djge66l8gdjqr1snlll9c0t04ha62htg6f@4ax.com>
References: <20100813214704.GA18960@kroah.com> <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com> <20100813230712.GA1703@suse.de> <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com> <20100814001158.GA2849@suse.de> <u2hc66pt2mnfqr0mhg0n76r5ucahg16dca@4ax.com> <20100814191224.GB5940@kroah.com>
In-Reply-To: <20100814191224.GB5940@kroah.com>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Aug 2010 12:12:24 -0700, you wrote:

>Thanks, can you try 2.6.52-rc2 now?  It should have the fix for this in
>it.

Yup, looks good here :)

http://bugsplatter.id.au/kernel/boxen/deltree/dmesg-2.6.27.52-rc2a.gz

Grant.
