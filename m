Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0FNKSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:18:35 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58760 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab0FNKSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:18:34 -0400
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Date: Mon, 14 Jun 2010 18:18:24 +0800
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>
References: <1275636608.606606.450179637764.0.gpush@pororo> <1275636608.607067.417709988883.1.gpush@pororo> <20100611042046.GA31045@fluff.org.uk>
In-Reply-To: <20100611042046.GA31045@fluff.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141818.26954.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

I've just pushed to my clk-common branch, mostly involving the changes we've 
discussed so far.

http://kernel.ubuntu.com/git?p=jk/dt/linux-2.6.git;a=commitdiff;h=f2c5141c88aa4c5ba82aee1b5b8abe5e9ff09146

The clk-common-mx51 and clk-common-versatile branches both contain basic ports 
of the mx51 and versatile platforms to the new clock infrastructure.

Cheers,


Jeremy
