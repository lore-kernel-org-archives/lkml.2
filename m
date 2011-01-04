Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1ADJFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:05:35 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41135 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab1ADJFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:05:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HNE9Qjy1wmOcnfLCkEOFH1++MBlb7SQE+5On3oGnFgkh75sCVJeL7HQ7OgPMZI/kDK
         meAwWsTZ2PE6FpEbkUV/rAA+tKC4KUWU2BHS8zKrd4RAOl9fTMbPBU8OnoHxe+vhciKk
         b2Gy8vAmvUMlcyyZIBGskUlE4wYa7mviSaIsA=
Message-ID: <4D22E2CF.5050002@gmail.com>
Date: Tue, 04 Jan 2011 17:05:19 +0800
From: YangSheng <sickamd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, adilger@dilger.ca,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        swhiteho@redhat.com, sickadm@gmail.com
Subject: Re: [PATCH resend] Update atime from future.
References: <1294131418-3835-1-git-send-email-sickamd@gmail.com> <m2d3od11p6.fsf@whitebox.home>
In-Reply-To: <m2d3od11p6.fsf@whitebox.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 05:02 PM, Andreas Schwab wrote:
> yangsheng<sickamd@gmail.com>  writes:
>
>    
>> -	 * Is the previous atime value older than a day? If yes,
>> +	 * Is the previous atime value old than a day? If yes,
>>      
> Why did you change that comment?
>    
Sorry, It is a typo. I'll resent it.
> Andreas.
>
>    

