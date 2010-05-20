Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0ETRfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:35:06 -0400
Received: from lo.gmane.org ([80.91.229.12]:38949 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab0ETRfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:35:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Subject: NR_CPUS configuration option wrong
Date: Thu, 20 May 2010 18:34:32 +0100
Message-ID: <ht3rr8$b5f$2@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 88-97-16-53.dsl.zen.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The configuration MAXSMP help text indicates it is used to enable 
configuration of number of CPUs. However, NR_CPUS depends on !MAXSMP.

arch/x86/Kconfig:
758 config NR_CPUS
759         int "Maximum number of CPUs" if SMP && !MAXSMP

Frank

