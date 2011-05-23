Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab1EWXge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 19:36:34 -0400
Received: from mail.perches.com ([173.55.12.10]:1907 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab1EWXgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 19:36:32 -0400
Subject: Re: [PATCH-v2] MAINTAINERS: Add drivers/target/ entry
From: Joe Perches <joe@perches.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1306185032-11629-1-git-send-email-nab@linux-iscsi.org>
References: <1306185032-11629-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 16:36:29 -0700
Message-ID: <1306193789.8687.61.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 14:10 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> +TARGET SUBSYSTEM
> +M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
> +L:	linux-scsi@vger.kernel.org
> +L:	http://groups.google.com/group/linux-iscsi-target-dev
> +W:	http://www.linux-iscsi.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
> +S:	Supported
> +F:	drivers/target/
> +F:	include/target/
> +F:	Documentation/target/

Shouldn't the file layout be more like

drivers/lio/target?


