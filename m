Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056Ab0J2Vvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 17:51:43 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:58119 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab0J2Vvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 17:51:42 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4CCB41E5.7030708@elektron.elka.pw.edu.pl>
Date: Fri, 29 Oct 2010 23:51:33 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SOLVED? Re: i915 module with modeset=1 freezes machine (kernels 2.6.33
 and 2.6.36)
References: <4CC751E8.9030505@elektron.elka.pw.edu.pl> <4CC7DDCC.7040605@elka.pw.edu.pl> <4CCB39BE.4080400@elektron.elka.pw.edu.pl>
In-Reply-To: <4CCB39BE.4080400@elektron.elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ve set two options in my kernel configuration:
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y

Now the system boots correctly with KMS switched on.

