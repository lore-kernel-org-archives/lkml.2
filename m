Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab1EPGZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 02:25:23 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46227 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab1EPGZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 02:25:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=GRLDhmC3SSsZPnCaIiZLsqyyrnaFU/6dkqYzFufU8VTuc3IErOAan+HpRTzQBDzvBx
         +qcW9HtKPHdKKeMF8+WGnghE+J5ljaCaSnJzGLjvVYi4XqAVwzxNJGGgwZ6Xv/bTVhGp
         rBL3muFmbCquPRNYjL1cYi5+vEuthr66nUsLQ=
From: Jordi Pujol <jordipujolp@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] tmpfs: implement generic xattr support
Date: Mon, 16 May 2011 08:25:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc7.jpp.8-lnet-amd64; KDE/4.4.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Suchanek <hramrach@centrum.cz>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>
References: <871v02lujw.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <871v02lujw.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Message-Id: <201105160825.09003.jordipujolp@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Divendres 13 Maig 2011 13:16:35, Miklos Szeredi va escriure:
> [This update addresses comments from Hugh and Andrew]

Hello,

there are few days that I am testing It and works fine
in a Live system with or without persistence. combined with overlayfs also.

Thanks,

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com
