Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0J3NfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 09:35:16 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:65399 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0J3NfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 09:35:14 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4CCC1EF3.1050007@elektron.elka.pw.edu.pl>
Date: Sat, 30 Oct 2010 15:34:43 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel configuration should warn when KMS is switched on but framebuffer
 console is not?
References: <4CC751E8.9030505@elektron.elka.pw.edu.pl> <4CC7DDCC.7040605@elka.pw.edu.pl> <4CCB39BE.4080400@elektron.elka.pw.edu.pl> <4CCB41E5.7030708@elektron.elka.pw.edu.pl>
In-Reply-To: <4CCB41E5.7030708@elektron.elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid the problems described in the above bug reports, maybe the kernel
configuration should check and warn when CONFIG_DRM_I915_KMS is set to "y"
while CONFIG_FRAMEBUFFER_CONSOLE is not set to "y"?

