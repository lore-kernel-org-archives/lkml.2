Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0IEDS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 23:18:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44803 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab0IEDS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 23:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=boAO6Jr/AD2CWBs5cRsOFg9/MFkptGZXZE7iWBsSwkA1ak1HRE2dGkLFmj/tXvEEMC
         pOL+gSDjMHqMSn01A81yJMf/x2+raP//b6eDbwbgJduCY9t4d5aMrKGl1KHC3xTMZ9d9
         +SESq+IMGKu8oQNWp4ymoxnbceHpcTTM+uhEc=
Date: Sun, 5 Sep 2010 12:21:48 +0900
From: Adam Jiang <jiang.adam@gmail.com>
To: runcoderen <runcoderzhcn@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ldd scull_load question
Message-ID: <20100905032148.GA9971@capricorn-x61>
Mail-Followup-To: runcoderen <runcoderzhcn@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1283160040-6636-1-git-send-email-nab@linux-iscsi.org>
 <201009020156.53803.konrad@darnok.org>
 <1283455187.5598.86.camel@haakon2.linux-iscsi.org>
 <1283644390.556.74.camel@haakon2.linux-iscsi.org>
 <1283646914.1741.3.camel@bencharluo-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283646914.1741.3.camel@bencharluo-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 08:35:14AM +0800, runcoderen wrote:
> hi all:
> I am reading ldd(3rd).
> when I read the scull_load part.
> I can't understand some special sentences in the scripts as follows:
> 
> /sbin/insmod ./$module.ko $* || exit 1
> 
> why we add $* and || exit 1 after /sbin/insmod ./$module.ko?
> can anyone help me to understand?

Hey,

The '$*' means bash variables. I believe it is a question not related to
Linux kernel. See

http://tldp.org/LDP/abs/html/othertypesv.html

/Adam

> 		runcoderen
> 
> -- 
> 
> /****************************************
> http://runcoderen.wordpress.com
> ****************************************/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
