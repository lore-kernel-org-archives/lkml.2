Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1EQDkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 23:40:17 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37521 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1EQDkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 23:40:15 -0400
Date: Mon, 16 May 2011 22:40:05 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Suchanek <hramrach@centrum.cz>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] tmpfs: implement generic xattr support
Message-ID: <20110517034005.GA7870@mail.hallyn.com>
References: <871v02lujw.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871v02lujw.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> [This update addresses comments from Hugh and Andrew]

Confirmed, with this patch, I was able to use file capabilities on tmpfs.

thanks,
-serge
