Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1ENRG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 13:06:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1ENRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 13:06:25 -0400
Date: Sat, 14 May 2011 13:06:14 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Suchanek <hramrach@centrum.cz>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Eric Paris <eparis@redhat.com>,
        James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] tmpfs: implement generic xattr support
Message-ID: <20110514170614.GP16221@bombadil.infradead.org>
References: <871v02lujw.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871v02lujw.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 01:16:35PM +0200, Miklos Szeredi wrote:
> [This update addresses comments from Hugh and Andrew]
> 

I just pulled this patch into Fedora rawhide so that I can beat on it
with tmpfs backed buildroots. I'll let you know if any issues arise.

--Kyle
