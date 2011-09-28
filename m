Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1I1ONa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:13:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab1I1ON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:13:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v3 22/24] C6X: EMIF - External Memory Interface
Date: Wed, 28 Sep 2011 16:13:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-23-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-23-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281613.27164.arnd@arndb.de>
X-Provags-ID: V02:K0:q5a8JtpfsbmUEz2F7BmiEdGr8kYVBH8UEMVwn9xCOe9
 hdBVI/3R6I+6eZ+CYPh4ntMgfpuuI4693R0zr9UbGlEz9WaS0A
 UjrNKs/f/P8J1puZ77VWgqu22koI1FJ1PRqD8cair/jThqyJYW
 2z4WYTUBn4z+4o8nW1kU5piL3+IdbTGbGmYEYcAOqaImBYlN7c
 kXFuiYFZoqvq/zRIHZrnwa4UCDP7ik3IwBQ/TpaTAIlWaF0Wfn
 twBB5nQzEAHftmwEiDwjLIhuZsLc8GzP8BQaGXhyEBhqDrS1M0
 Bk1Q3WU03fXJniIy9wllQ5TwzInQsYjHBbttgUsSC8m09aOJ5l
 THFZMgGhuvNHntddGgqA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 September 2011, Mark Salter wrote:
> Several SoC parts provide a simple bridge to support external memory mapped
> devices. This code probes the device tree for an EMIF node and sets up the
> bridge registers if such a node is found. Beyond initial set up, there is no
> further need to access the bridge control registers. External devices on the
> bus are accessed through their MMIO registers using suitable drivers. The
> bridge hardware does provide for timeout and other error interrupts, but these
> are not yet supported.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
