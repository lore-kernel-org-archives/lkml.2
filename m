Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762013Ab0J2VRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 17:17:39 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:57876 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0J2VRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 17:17:37 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4CCB39BE.4080400@elektron.elka.pw.edu.pl>
Date: Fri, 29 Oct 2010 23:16:46 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: More details - Re: i915 module with modeset=1 freezes machine
 (kernels 2.6.33 and 2.6.36)
References: <4CC751E8.9030505@elektron.elka.pw.edu.pl> <4CC7DDCC.7040605@elka.pw.edu.pl>
In-Reply-To: <4CC7DDCC.7040605@elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 82865G based system boots correctly with debian distribution kernel 
linux-image-2.6.32-5-686 .
I tried to copy settings related to DRM, framebuffers and other graphics 
related options from 2.6.32-5 to my self-compiled 2.6.36 kernel, but it 
still hangs.

