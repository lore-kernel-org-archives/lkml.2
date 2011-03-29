Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1C2X6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:58:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33971 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab1C2X6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:58:17 -0400
Subject: Should corrected machine check errors still taint the kernel?
From: Max Asbock <masbock@linux.vnet.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain
Date: Tue, 29 Mar 2011 16:58:17 -0700
Message-Id: <1301443098.5867.34.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that corrected machine check errors taint the kernel. And it
looks like they have done that forever.

Is that still the right thing to do?

The comment in add_taint() says:
"Can't trust the integrity of the kernel anymore."

I don't think that's necessarily the case after seeing a corrected
memory error.

thanks,
Max 

