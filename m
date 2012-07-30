Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2G3MBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 08:01:14 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:5401 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2G3MBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 08:01:13 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=6EiD1NdcSfOyZy46iz51sWuwP7QBAuIM9gW4V5dN1HzdLK7/+T/zeFAx1qZy
	850YrS0w4m/RTVBymmYkPFSdOwedvZgm64kOEjL6cZfY+9stzzKUX9aAs
	vHEs3CySW20yq7nZeHBKWwhPnli6J27gGthEq6OSoG6vh43xSK4fKU=;
X-Spam-Processed: mail.digidescorp.com, Mon, 30 Jul 2012 07:01:02 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1558eb3138=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1343649657.2153.2.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH] Documentation: update mount option in
 filesystem/vfat.txt
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Jul 2012 07:00:57 -0500
In-Reply-To: <1343559005-7661-1-git-send-email-linkinjeon@gmail.com>
References: <1343559005-7661-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-29 at 06:50 -0400, Namjae Jeon wrote: 
> update two mount option(discard, nfs) in vfat.txt.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---

Thanks. I knew there must be somewhere to document mount options but I
thought it would be in the userspace tools (util-linux).

Reviewed-by: Steven J. Magnani <steve@digidescorp.com>
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>




