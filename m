Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1BESEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 13:04:01 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:36948 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1BESEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 13:04:00 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH -V2 0/17] Buffered write and writeable mmap support for 9P
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Notmuch/0.5-64-gc3ae51d (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Sat, 05 Feb 2011 23:33:51 +0530
Message-ID: <87ei7mxss8.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  5 Feb 2011 23:16:28 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> The patch series implement buffered write and writeable mmap for 9P
> 
> Changes from V1:
> a) Add fsync and syncfs support
> 

I haven't yet addressed the previous review feedback from
Miklos. http://article.gmane.org/gmane.linux.kernel/1093869
Running 9p server and client on the same host even though possible
is not a strong use case at this point. I will get to that later.

The patch series also don't address cache consistency issue that
can arise due to direct modification in the server. I am not
sure we need to complicate the client code for that considering
the cache model that we follow is loose. 

In short the set of patches help the virtualization pass-through use case
(http://wiki.qemu.org/Documentation/9psetup)

-aneesh
