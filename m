Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab0HBO3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:29:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59382 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0HBO3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=o+CJAKbpedsKhgqx47vuMSZDtettbg3VVPnlWk4X1kMed04U/7L5Y90daZooBckOVN
         lkIcR2BhBSfPBy23Q0cNnJNHrbSFiFW2MQBQVRLwy2BsB5/+6AocZt4kAoKpR57fNjYN
         qeKkCSuSz0XBfuKpw7VKGD4EBVIY+ygkvc2W0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=keL2rUzxdxgscTU9cQSNxOnAtGVuAwTq9Wfuq@mail.gmail.com>
References: <AANLkTik7powjUaJ51bA_bgPVb03U-RVZay3NffHBYLzx@mail.gmail.com>
	<215375.1280753770@localhost>
	<AANLkTi=keL2rUzxdxgscTU9cQSNxOnAtGVuAwTq9Wfuq@mail.gmail.com>
Date: Mon, 2 Aug 2010 22:29:41 +0800
Message-ID: <AANLkTikjUtTwaP5-LnYX8v3hjcuVbtenoH-yFvcPGf-+@mail.gmail.com>
Subject: RE: a Great Idea - include Kademlia networking protocol in kernel
From: hp fk <fkhp101@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: hp fk <fkhp101@gmail.com>
Date: 2010/8/2
Subject: Re: a Great Idea - include Kademlia networking protocol in kernel
To: Valdis.Kletnieks@vt.edu


popular file sharing p2p applications like emule and bittorrent,
innovative application like Osiris each has its own Kademlia protocol
implementation in userspace presently. the imaginable kernel support
needed is to reduce many repeated (different or same) Kademlia
protocol implementations running in userspace to a consolidated one at
kernel level, so that the Kademlia protocol as a p2p network
infrastructure is provided in kernel and any p2p application could
just use the interface provided by kernel, thus a great p2p network is
easily created, and  applications on that network infrastructure could
grow rapidly.

2010/8/2  <Valdis.Kletnieks@vt.edu>:
> 1) You failed to explain what kernel support, if any, would be needed for this
> protocol.
