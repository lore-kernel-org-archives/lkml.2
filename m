Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1JJKWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:22:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52086 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1JJKWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:22:38 -0400
MIME-Version: 1.0
In-Reply-To: <f6af3ca08d9e966de00d77cc9a8251d91666f33f.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	<cover.1318233879.git.joe@perches.com>
	<f6af3ca08d9e966de00d77cc9a8251d91666f33f.1318233879.git.joe@perches.com>
Date: Mon, 10 Oct 2011 19:22:37 +0900
Message-ID: <CAKYAXd_fkTJe6bm_0sVty-SqrFSHpifbH6Cvb-oPA+622A=gbg@mail.gmail.com>
Subject: Re: [PATCH 5/6] udf: Neaten logging output, use vsprintf extension %pV
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/10 Joe Perches <joe@perches.com>:
> Remove the warning and error prefixes that duplicate KERN_<level>.
> Use %pV and remove a static buffer to save some text space.
>
> Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
> ---
