Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab0L1UEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:04:37 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48600 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0L1UEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=r7ld7vt3iLOom6zqALB414zlLv+bwGIgVR9E8HjbqDNxvqMFZHEQMRr1Lefg/26d/G
         DuYKznOZ4ofbZy8O/EtRXayeIynOxVrDVFs6XLp8XVDuZMRtkssM3fjyqtg2sKhNa9X3
         RbCNGyhikF1lLiQVWOBlDjqo6T6Z5Fp8wPUdw=
Message-ID: <4D1A42D1.1000309@garzik.org>
Date: Tue, 28 Dec 2010 15:04:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: Re: [PATCHSET] block: convert block drivers to ->check_events()
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
In-Reply-To: <1293557352-10592-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2010 12:28 PM, Tejun Heo wrote:
> This patchset converts all in-kernel block drivers from
> ->media_changed() to ->check_events().  Most conversions are fairly
> mechanical.  The only notable exceptions are,

Even though this does not directly touch libata, I feel compelled to add 
an 'ACK' to this patch series.  Good stuff.


