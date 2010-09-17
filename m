Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0IQGNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 02:13:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34952 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab0IQGNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 02:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tSERbreUrk7J9J1ekGKuk4r1uHg1nQFQ6MrqXrrwgSvpPwamB9p1NLZ1d8cytbvsi2
         II5EoapK3/zOc0cD5gwrRAU9wcAgH6d0j+oL2dZ07dAYTn9FEuBX44Wtf7PUqfUVT17B
         cMRGsaM8NiwBGhAthkzk6kLl03pN0heZleszs=
Message-ID: <4C9306FF.70202@pobox.com>
Date: Fri, 17 Sep 2010 02:13:19 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: reorder ata_queued_cmd to remove alignment padding
 on 64 bit builds
References: <1284117583.1903.8.camel@castor.rsk>
In-Reply-To: <1284117583.1903.8.camel@castor.rsk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 07:19 AM, Richard Kennedy wrote:
> Reorder structure ata_queued_cmd to remove 8 bytes of alignment padding
> on 64 bit builds&  therefore reduce the size of structure ata_port by
> 256 bytes.
>
> Overall this will have little impact, other than reducing the amount of
> memory that is cleared when allocating ata_ports.
>
> Signed-off-by: Richard Kennedy<richard@rsk.demon.co.uk>
> ----
> patch against 2.6.36-rc3
> compiled&  tested on x86_64
>
> I've been running this patch for a couple of weeks with no apparent
> issues.
>
> regards

applied


