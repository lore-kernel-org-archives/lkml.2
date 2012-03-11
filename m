Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2CKMrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:47:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62412 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2CKMrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:47:15 -0400
Message-ID: <4F5C9ECF.8060803@redhat.com>
Date: Sun, 11 Mar 2012 13:47:11 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Hu Tao <hutao@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v3 2/2] virtio-scsi: add error handling
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com> <1324296188-3426-3-git-send-email-pbonzini@redhat.com> <20120310084806.GB24958@localhost.localdomain>
In-Reply-To: <20120310084806.GB24958@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/03/2012 09:48, Hu Tao ha scritto:
> Is there a race here that the cmd may have been already freed (by
> virtscsi_complete_free) after waking up from the completion?

Looks right, can you submit with a Signed-off-by?

Paolo
