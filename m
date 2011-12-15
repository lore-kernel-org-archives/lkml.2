Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584Ab1LOWRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:17:21 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37573 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1LOWRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:17:19 -0500
Subject: Re: [PATCH] input: signedness bug in cma3000_thread_irq()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <3797.1323919260@turing-police.cc.vt.edu>
Date: Thu, 15 Dec 2011 17:17:02 -0500
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F920F5EE-FA61-4FFC-948C-97D6834823B6@gmail.com>
References: <1323672566-16738-1-git-send-email-xi.wang@gmail.com> <12775.1323916035@turing-police.cc.vt.edu> <ECD4A42B-AC97-417B-99CA-3856B5DAFAC6@gmail.com> <3797.1323919260@turing-police.cc.vt.edu>
To: Valdis.Kletnieks@vt.edu
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2011, at 10:21 PM, Valdis.Kletnieks@vt.edu wrote:
> No, the variable that used to be a u8 - was it 8 bits wide for a reason?

The return value of CMA3000_READ?  I don't see any particular reason.  

- xi
