Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab0HINCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:02:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60061 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0HINCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=n6F8PklTft/ZwkbNzTl9lMEgIC7kgqrNiIcHlCn2UMQc1cnWkVJ/kUhrE+bAVE9VdO
         MAcz/AXHbt5WmkaYiL63sik+5FlX/29Q0WW5W0sL3tU/vvhLux8V5uDmEwV0N3zL9GZH
         hIoyNFagSGLTQ6W0RsHUHZ3fjQhkbxxgNLdGQ=
MIME-Version: 1.0
Date: Mon, 9 Aug 2010 09:02:51 -0400
Message-ID: <AANLkTimvSygr1DqMnc97RVsaXik9s+iFRHUaXrHPyYiQ@mail.gmail.com>
Subject: is nfsd sync or async?
From: Yuehai Xu <yuehaixu@gmail.com>
To: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Cc: yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Suppose there is only one nfsd and two clients are sending random read
requests to this daemon. In this way, read ahead of the client should
not work since the requests are random. The requests between these two
clients should be async, while the requests from any one client of the
two should be sync. My question is about how will the nfsd handle
these requests, using sync or async mode in the kernel? Say, will nfsd
never handle the next request unless the previous request has been
served, without considering which clients the request belongs to? Or
nfsd just dispatch async requests to the lower level as soon as it
receives a request?

Any answer will be appreciated!

Yuehai
