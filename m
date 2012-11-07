Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2KGTFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:05:42 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:39891 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2KGTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:05:41 -0500
Date: Wed, 7 Nov 2012 14:05:22 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <David.Woodhouse@intel.com>, davem@davemloft.net
Subject: Re: [PATCH v3 2/7] atm: add owner of push() callback to atmvcc
Message-ID: <20121107140522.257c541c@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1352240222-363-3-git-send-email-krzysiek@podlesie.net>
References: <1352240222-363-1-git-send-email-krzysiek@podlesie.net>
	<1352240222-363-3-git-send-email-krzysiek@podlesie.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Nov 2012 23:16:57 +0100
Krzysztof Mazur <krzysiek@podlesie.net> wrote:

> The atm is using atmvcc->push(vcc, NULL) callback to notify protocol
> that vcc will be closed and protocol must detach from it. This callback
> is usually used by protocol to decrement module usage count by module_put(),
> but it leaves small window then module is still used after module_put().
> 
> Now the owner of push() callback is kept in atmvcc and
> module_put(atmvcc->owner) is called after the protocol is detached from vcc.
> 
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>

Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>
