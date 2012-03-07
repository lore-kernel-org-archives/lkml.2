Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499Ab2CGSAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:00:23 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48397 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab2CGSAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:00:18 -0500
MIME-Version: 1.0
In-Reply-To: <3290280b610108e3766e1f82b7d8c74cb688cba5.1331137504.git.jbaron@redhat.com>
References: <cover.1331137504.git.jbaron@redhat.com> <3290280b610108e3766e1f82b7d8c74cb688cba5.1331137504.git.jbaron@redhat.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Wed, 7 Mar 2012 09:59:58 -0800
Message-ID: <CAB=4xhrVbjSiMOA=SyQ_SMROm6uWd3a-b4j987wYsJzMD7pm3g@mail.gmail.com>
Subject: Re: [PATCH 1/2] core dump: drop VM_ALWAYSDUMP flag
To: Jason Baron <jbaron@redhat.com>
Cc: akpm@linux-foundation.org, avi@redhat.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 9:00 AM, Jason Baron <jbaron@redhat.com> wrote:
> +       if (vma_name) {
> +               if ((strcmp(vma_name, "[vdso]") == 0) ||
> +                   (strcmp(vma_name, "[vectors]") == 0) ||
> +                   (strcmp(vma_name, "[vsyscall]") == 0))

That's just disgusting.
