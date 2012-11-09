Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2KIUPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:15:06 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:48549 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab2KIUPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:15:03 -0500
Date: Fri, 9 Nov 2012 20:15:02 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH v3 7/9] trace: use this_cpu_ptr per-cpu helper
In-Reply-To: <509C68C1.3040501@gmail.com>
Message-ID: <0000013ae6cfb10f-87b4a0ea-98fe-4269-a834-9ebb64fe61fa-000000@email.amazonses.com>
References: <509C68C1.3040501@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Shan Wei wrote:

> -	return buffer->buffer;
> +	return (char *)this_cpu_ptr(&percpu_buffer->buffer);
>  }

Add a comment to explain the cast?

