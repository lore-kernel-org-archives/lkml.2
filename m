Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2JOTt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:49:58 -0400
Received: from void.printf.net ([89.145.121.20]:39401 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab2JOTt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:49:56 -0400
From: Chris Ball <cjb@laptop.org>
To: "Mikko C." <mikko.cal@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel panic on CentOS
References: <507C66E0.6070802@gmail.com>
Date: Mon, 15 Oct 2012 15:49:51 -0400
In-Reply-To: <507C66E0.6070802@gmail.com> (Mikko C.'s message of "Mon, 15 Oct
	2012 21:41:20 +0200")
Message-ID: <87fw5fy0ps.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 15 2012, Mikko C. wrote:
> we keep getting kernel panics on our CentOS 6.3 server, running about
> 40 KVM virtual machines.
>
> Here's the screenshot of the trace: http://i.imgur.com/yaRyF.png

The presence of machine_check() suggests that you have a hardware
problem that the kernel doesn't know how to recover from.
(Although you only sent part of the trace.)

http://en.wikipedia.org/wiki/Machine_Check_Exception

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
