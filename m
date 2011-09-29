Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab1I2TFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:05:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab1I2TFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:05:23 -0400
Date: Thu, 29 Sep 2011 15:05:19 -0400
From: Dave Jones <davej@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.1rc7+ FSX failure over NFS
Message-ID: <20110929190519.GA15165@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110929184127.GA12236@redhat.com>
 <1317322772.8708.30.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317322772.8708.30.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 02:59:32PM -0400, Trond Myklebust wrote:
 
 > 1) What filesystem are you using on the server, and does that filesystem
 > support high resolution timestamps?

ext3

 > 2) Does the file length on the server match the reported erroneous file
 > length on the client?

No. Server side is 213853 bytes (0x3435d)

 > 3) Do the mtime and ctime on the erroneous file match on the client and
 > server?
 
both show..
Modify: 2011-09-29 13:50:00.000000000 -0400

	Dave

