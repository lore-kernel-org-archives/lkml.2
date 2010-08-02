Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0HBQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:25:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52143 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab0HBQZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:25:24 -0400
Subject: Re: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM
 virtio-net.
From: Shirley Ma <mashirle@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, mingo@elte.hu,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
In-Reply-To: <4C56EE3D.1050203@redhat.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com>
	 <1280442682.9058.15.camel@localhost.localdomain>
	 <4C525CD2.5080604@redhat.com>
	 <1280504771.9058.25.camel@localhost.localdomain>
	 <4C552DC4.5000600@redhat.com>
	 <1280764918.22830.7.camel@localhost.localdomain>
	 <4C56EE3D.1050203@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 09:25:19 -0700
Message-ID: <1280766319.22830.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 19:11 +0300, Avi Kivity wrote:
> I don't understand this. gup_fast() only calls gup() if the page is 
> swapped out or read-only.

Oh, I used the page as read-only on xmit path. Should I use write
instead?

Thanks
Shirley

