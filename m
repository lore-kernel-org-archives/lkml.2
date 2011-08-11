Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab1HKWrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 18:47:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58936
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801Ab1HKWr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 18:47:29 -0400
Date: Thu, 11 Aug 2011 18:47:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH v3 3/3] drivers/block/mtip32xx: Adding Makefile and
 Kconfig
Message-ID: <20110811224725.GB10182@infradead.org>
References: <22A973199D2C2F46933448F6E7990A3002C80029@ntxboimbx31.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22A973199D2C2F46933448F6E7990A3002C80029@ntxboimbx31.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the driver at least needs to depend on PCI.

