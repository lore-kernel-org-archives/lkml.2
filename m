Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab1CDJL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:11:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285Ab1CDJL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:11:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 1/1] PRUSS UIO driver support
Date: Fri, 4 Mar 2011 10:11:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: Pratheesh Gangadhar <pratheesh@ti.com>, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, sshtylyov@mvista.com,
        amit.chatterjee@ti.com, gregkh@suse.de, hjk@hansjkoch.de,
        tglx@linutronix.de
References: <1299213772-21931-1-git-send-email-pratheesh@ti.com> <1299213772-21931-2-git-send-email-pratheesh@ti.com>
In-Reply-To: <1299213772-21931-2-git-send-email-pratheesh@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041011.36932.arnd@arndb.de>
X-Provags-ID: V02:K0:G3Eg70gNTTRKhBVv5/rtiQIMrcHlzbXTpdIc1lJidWl
 7xTZMibILifTytspHNEQ7h1eUX6NieEoWx+m5GCDpP6kvzwaMZ
 A8gELoogq3xLdiqCfaYS+8DHfv1iR6fOmcBqQzx+Msa0HY3Xj2
 /2t02BQPM+l8BPIBU7TBgigpW9hi69dElii9jRawam0NrX69hy
 o3GhdTjEl/XYIV1+BEgFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 March 2011 05:42:52 Pratheesh Gangadhar wrote:
> This patch implements PRUSS (Programmable Real-time Unit Sub System)
> UIO driver which exports SOC resources associated with PRUSS like
> I/O, memories and IRQs to user space. PRUSS is dual 32-bit RISC
> processors which is efficient in performing embedded tasks that
> require manipulation of packed memory mapped data structures and
> handling system events that have tight real time constraints. This
> driver is currently supported on Texas Instruments DA850, AM18xx and
> OMAP-L138 devices.
> For example, PRUSS runs firmware for real-time critical industrial
> communication data link layer and communicates with application stack
> running in user space via shared memory and IRQs.
 
Looks good

> Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
