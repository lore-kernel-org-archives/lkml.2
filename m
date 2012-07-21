Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2GUMCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 08:02:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62148 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2GUMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 08:02:31 -0400
Message-ID: <500A9A72.20507@gmail.com>
Date: Sat, 21 Jul 2012 14:02:58 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 4/5] virtio_net: multiqueue support
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <1341484194-8108-5-git-send-email-jasowang@redhat.com> <20120720134014.GD16550@redhat.com>
In-Reply-To: <20120720134014.GD16550@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2012 03:40 PM, Michael S. Tsirkin wrote:
>> -	err = init_vqs(vi);
>> > +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>> > +		vi->has_cvq = true;
>> > +
> How about we disable multiqueue if there's no cvq?
> Will make logic a bit simpler, won't it?

multiqueues don't really depend on cvq. Does this added complexity really justifies adding an artificial limit?


