Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab2GWNgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 09:36:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57817 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab2GWNgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 09:36:23 -0400
Date: Mon, 23 Jul 2012 14:36:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Miguel =?iso-8859-1?Q?G=F3mez?= <magomez@igalia.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>, don@syst.com.br,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] classmate-laptop: Add support for Classmate V4
 accelerometer.
Message-ID: <20120723133618.GC21838@srcf.ucam.org>
References: <cover.1340976795.git.magomez@igalia.com>
 <39ac42c709e498fbef4f0f0f24edc5331e5f4473.1340976795.git.magomez@igalia.com>
 <20120717224749.GA20813@nautilus.holoscopio.com>
 <5006BFEC.1010407@igalia.com>
 <20120723132841.GD21495@srcf.ucam.org>
 <500D52A7.8040606@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <500D52A7.8040606@igalia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 03:33:27PM +0200, Miguel Gómez wrote:

> Names are upper-cased in acpica, so the device is reported as
> FNBT0000. But in the driver it's named FnBT0000, and that's why it
> doesn't match.

So just change the existing entry in the driver to FNBT0000?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
