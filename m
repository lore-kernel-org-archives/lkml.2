Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0F2VHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:07:47 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60125 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066Ab0F2VHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:07:45 -0400
X-Sasl-enc: dLqYmjjgjYa3e8/NBP5T3hxTiZr+eGh6RawQl9H9f1C8 1277845664
From: Bernd Schubert <bernd.schubert@fastmail.fm>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 23:07:41 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006292307.42440.bernd.schubert@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 29, 2010, David Howells wrote:
> Implement a pair of new system calls to provide extended and further
> extensible stat functions.

Is there any chance we can use that chance and also add a field 

unsigned long long st_gen

to struct_ xstat? Inode generation numbers really would be useful for 
userspace NFS servers and some fuse filesystems.


Thanks,
Bernd
