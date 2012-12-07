Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2LGHCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:02:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49897 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab2LGHCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:02:50 -0500
Date: Fri, 7 Dec 2012 15:02:41 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: A typo about kernelcore= ?
Message-ID: <20121207070241.GA2464@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120707-9360-0000-0000-00000DA45189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I'm wondering this is a typo in Documentation/kernel-parameters.txt
about "kernelcore=":
    
    .... In the event, a node is too small to have both
    kernelcore and Movable pages, kernelcore pages will
    take priority and other nodes will have a larger number
    of kernelcore pages.

I think it should be 

    .... In the event, a node is too small to have both
    kernelcore and Movable pages, kernelcore pages will
    take priority and other nodes will have a larger number
    of *Movable* pages.

Is it right? Thanks in advance!

