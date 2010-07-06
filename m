Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0GFILT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:11:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab0GFILR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:11:17 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: axel.lin@gmail.com
Subject: Re: [PATCH] hp-wmi: add return value checking for input_allocate_device()
Date: Tue, 6 Jul 2010 10:11:14 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Anisse Astier <anisse@astier.eu>,
       platform-driver-x86@vger.kernel.org
References: <1278383426.12801.15.camel@mola> <201007060956.45726.trenn@suse.de> <AANLkTimpkmAoPep9s1Hp5gZvdjzDm_1iBO32xYeAQL5F@mail.gmail.com>
In-Reply-To: <AANLkTimpkmAoPep9s1Hp5gZvdjzDm_1iBO32xYeAQL5F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007061011.15205.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 July 2010 10:07:49 Axel Lin wrote:
> hi Thomas,
> 2010/7/6 Thomas Renninger <trenn@suse.de>:
...
> > Do you mind to incorporate above if you agree.
> 
> Checking hp_wmi_input_setup() is already done in my previous patch.
> ( which is already merged in platform-driver-x86 tree.
...
Perfect!
Acked-by: Thomas Renninger <trenn@suse.de>

     Thomas
