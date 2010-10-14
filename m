Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0JNSHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 14:07:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40227 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0JNSHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 14:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rqkosvB3fWha/7aZS9qh4PhZZxFJhrtgXw9WutQ75VGZ0wD4WLa/jshr4qrfdHKnMR
         R2RW2aP02iKamugf10vNd/6q6l3N3fYYArnRx1jTpb12m/agSBxwcuDLo/NX4xNuIMad
         lO1EevEtCS6BasEedYMO3nRYX94WGsJpElC/M=
Message-ID: <4CB745FC.5090504@gmail.com>
Date: Thu, 14 Oct 2010 20:03:40 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Chris Frey <cdfrey@foursquare.net>, Jens Axboe <jaxboe@fusionio.com>,
        Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        "janjaap@bos.nl" <janjaap@bos.nl>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "syzop@vulnscan.org" <syzop@vulnscan.org>
Subject: Re: [PATCH 1/1] um: ubd: Fix data corruption
References: <20100928225202.GA30352@foursquare.net> <4CA275CE.6060401@fusionio.com> <20100929012945.GA3324@foursquare.net> <4CA2CCC3.8010307@fusionio.com> <20100929063452.GA13290@foursquare.net> <4CAA02D0.7040901@gmail.com> <20101004195152.GA31583@foursquare.net> <4CAAE077.9010500@gmail.com> <20101005203137.GA594@foursquare.net> <4CAD7D98.7080808@fusionio.com> <20101007202339.GA8338@foursquare.net> <4CB70234.3030308@gmail.com> <AANLkTi=ni-zEfCMXLR8BJyPQcwzEKAUKYs4uH7ur12Fk@mail.gmail.com>
In-Reply-To: <AANLkTi=ni-zEfCMXLR8BJyPQcwzEKAUKYs4uH7ur12Fk@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/14/2010 04:20 PM, richard -rw- weinberger wrote:
> It does not work for me.
> But the error is a different one. :-)
> Without your patch I've never got this kernel trace.
> 
> [   59.850000] kworker/0:1: page allocation failure. order:0, mode:0x20

Hmm... you're seeing out of memory condition.  If the code screws up
filesystem access, I suppose it could make that happen too but can you
please check the configuration just in case (especially the memory
size)?  Also, if you can reliably reproduce the filesystem corruption
w/o the patch, can you please tell me how to do it?

Thanks.

-- 
tejun
