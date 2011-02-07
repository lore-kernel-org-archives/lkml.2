Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1BGV7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:59:53 -0500
Received: from smtp-out.google.com ([74.125.121.67]:5790 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab1BGV7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:59:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=xc3jv9ZltWwt4jNdmokj5MOGjtld7U3OmQQmwh2Buj0wiN76DJIFi7S8h3iWX2sd1u
         akf7f4nTyQi6euu1LZDQ==
MIME-Version: 1.0
Date: Mon, 7 Feb 2011 13:59:46 -0800
Message-ID: <AANLkTimrDXBjq5waZb6-5_Zb48Dfe+okt6LH0d16vc2b@mail.gmail.com>
Subject: Target for blk-cgroup CFQ code
From: Chad Talbott <ctalbott@google.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Michael Rubin <mrubin@google.com>,
        Justin TerAvest <teravest@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

We're going to be sending some patches against CFQ that expand on the
blk-cgroup functionality and I wanted to confirm that they should be
against git://git.kernel.dk/linux-2.6-block.git

Do you have any particular preferences (patch naming conventions,
etc.) that differ from Linus' guidelines?

Thanks,
Chad
