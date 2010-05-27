Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0E0VD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:03:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52424 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab0E0VD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:03:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vBV8EtS4aDeQSEQgbWZjyfo6jVlnFb3yqMgHVlHHE88xZvn+IuQymq1omhv2KF/rnv
         IH72Pq6+rqkiQLV2fWjDSyCgBiXmo8oTGvL1a8jXntm4ZETtY6H5k/t+rwGRoXXgl2ST
         jZphvytP50tf/WjK1fVs4TvP7y6uJ1Mi9RjTY=
Message-ID: <4BFEDE4F.80604@gmail.com>
Date: Thu, 27 May 2010 14:04:15 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: ath9k-devel@venema.h4ckr.net, mcgrog@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]wireless:ath9k Fix ath_print in xmit.c
References: <1274892555-10422-1-git-send-email-justinmattock@gmail.com> <adaeigxvz5j.fsf@roland-alpha.cisco.com>
In-Reply-To: <adaeigxvz5j.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 01:59 PM, Roland Dreier wrote:
>   >  -			  "Unable to stop TxDMA. Reset HAL!\n");
>   >  +			  "Unable to stop TxDMA. Reseting hardware!\n");
>
> I hate to mention it but the correct spelling is "resetting."
>    
no.. mention it!!
anyways the resend is here:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/51431

Justin P. Mattock
