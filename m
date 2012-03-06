Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2CFKdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 05:33:09 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:43730 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab2CFKdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 05:33:07 -0500
Date: Tue, 6 Mar 2012 11:33:02 +0100
From: Bastian Blank <waldi@debian.org>
To: Thomas Goirand <zigo@debian.org>
Cc: Dan Williams <dan.j.williams@intel.com>, xen-devel@lists.xensource.com,
        Dave Jiang <dave.jiang@intel.com>,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
Message-ID: <20120306103301.GA18077@wavehammer.waldi.eu.org>
Mail-Followup-To: Thomas Goirand <zigo@debian.org>,
	Dan Williams <dan.j.williams@intel.com>,
	xen-devel@lists.xensource.com, Dave Jiang <dave.jiang@intel.com>,
	pkg-xen-devel@lists.alioth.debian.org,
	Maciej Sosnowski <maciej.sosnowski@intel.com>,
	linux-kernel@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
	William Dauchy <wdauchy@gmail.com>,
	Konrad Rzeszutek Wilk <konrad@darnok.org>
References: <4F4891B8.9050008@goirand.fr>
 <20120302055715.GA692@burratino>
 <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
 <20120302162159.GB31683@wavehammer.waldi.eu.org>
 <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
 <20120302175719.GA1468@wavehammer.waldi.eu.org>
 <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
 <4F54DB1F.3080000@debian.org>
 <CABE8wwtOwgiYwb-_g-3Fg_QH6ph7LEPdkcOff94inDFvs9kwxA@mail.gmail.com>
 <4F55D6F6.2040906@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F55D6F6.2040906@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 05:20:54PM +0800, Thomas Goirand wrote:
> Please find attached the log that you asked me, with WARN_ON instead of
> BUG_ON, and with the 2 #define DEBUG in dma.c and dma_v2.c.

| ioatdma 0000:00:16.1: desc[1]: (0x27ea6d040->0x27ea6d080) cookie: 0 flags: 0x0 ctl: 0x0 (op: 0 int_en: 0 compl: 0)
| ioatdma 0000:00:16.1: desc[1]: (0x27ea6d040->0x27ea6d080) cookie: 0 flags: 0x31 ctl: 0x9 (op: 0 int_en: 1 compl: 1)

*counting* 9 hex digest, aka > 2^32. What did I say?

Bastian

-- 
The joys of love made her human and the agonies of love destroyed her.
		-- Spock, "Requiem for Methuselah", stardate 5842.8
