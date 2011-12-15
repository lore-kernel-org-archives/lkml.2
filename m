Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab1LOCf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:35:28 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40581 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1LOCf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:35:27 -0500
Subject: Re: [PATCH] input: signedness bug in cma3000_thread_irq()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <12775.1323916035@turing-police.cc.vt.edu>
Date: Wed, 14 Dec 2011 21:35:22 -0500
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <ECD4A42B-AC97-417B-99CA-3856B5DAFAC6@gmail.com>
References: <1323672566-16738-1-git-send-email-xi.wang@gmail.com> <12775.1323916035@turing-police.cc.vt.edu>
To: Valdis.Kletnieks@vt.edu
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2011, at 9:27 PM, Valdis.Kletnieks@vt.edu wrote:
> That will fix the signed/unsigned issue.  However, was there a reason
> the field was an 8-bit-wide to begin with?

Which field?  The ->read() function pointer?

- xi
