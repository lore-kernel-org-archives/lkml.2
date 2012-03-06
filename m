Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab2CFFWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 00:22:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62008 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2CFFWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 00:22:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.68.196.201 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1331011348.2474.28.camel@edumazet-laptop>
Subject: Re: 3.3.0-rc5: OOps in dql_completed (Broadcom tg3 driver)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tom Herbert <therbert@google.com>
Cc: Christoph Lameter <cl@gentwo.org>, mcarlson@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 05 Mar 2012 21:22:28 -0800
In-Reply-To: <CA+mtBx8oiDq+k3U705xYaV3xUsi=DnSWwCkymEONRcX3su77Fg@mail.gmail.com>
References: <alpine.DEB.2.00.1203011505510.6685@router.home>
	 <1330698646.2469.28.camel@edumazet-laptop>
	 <CA+mtBx_vNcPr-q7FSKXCAsVqvjZt=4UpWfv5eAp0=diG0wnbjQ@mail.gmail.com>
	 <CA+mtBx8oiDq+k3U705xYaV3xUsi=DnSWwCkymEONRcX3su77Fg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 05 mars 2012 à 21:14 -0800, Tom Herbert a écrit :
> BQL implementation for tg3 does not handle multi queue correctly.
> Will have a fix for that momentarily.
> 

Ah good catch. 

I never had a multi queue tg3, I couldnt figure out this :)


