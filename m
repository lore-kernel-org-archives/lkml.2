Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0G0XLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:11:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41715 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab0G0XLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=AN5lT/HXyX8+GwMfa51/LeO326IpLT+2pSleZY/DS22ZOlpVldRkGplkuEIP8vU2E9
         qHv7jDGuoH36u4HZQbH/i2EQlF8PIBnYEaEwzCOYCtdihND9FfcxnDiZMslD2fNu8va2
         zz6NxtZTnnqgYabgXdgswhRjdwjsDSBF/jfAE=
From: Diego Calleja <diegocg@gmail.com>
Reply-To: diegocg@gmail.com
To: bchociej@gmail.com
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
Date: Wed, 28 Jul 2010 01:10:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-00019-g86c65a7; KDE/4.4.5; x86_64; ; )
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
        mrlupfer@us.ibm.com, crscott@us.ibm.com, linux-kernel@vger.kernel.org
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
In-Reply-To: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007280110.46059.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Miércoles, 28 de Julio de 2010 00:00:18 bchociej@gmail.com escribió:
> With Btrfs's COW approach, an external cache (where data is moved to
> SSD, rather than just cached there) makes a lot of sense. Though these

As I understand it, what your proyect intends to do is to move "hot"
data to a SSD which would be part of a Btrfs pool, and not do any
kind of SSD caching, as bcache (http://lwn.net/Articles/394672/) does?
