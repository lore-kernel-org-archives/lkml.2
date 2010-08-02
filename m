Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab0HBPCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:02:05 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42578 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0HBPCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=FDecmzmuyY3qNgP06ERAphasx1RKkAq0TRTpyRQ+EJSFI5TeS2SVO9X0OZcxAUyoBv
         9WIExqJUVXCs3TlJRgSOYoHm5+fIOYDzZzgh5NjcJ02QM/37o37gxKYCoN1ULjkAqoyP
         Mdg9mvVM1y0QdxED51C8olfoJ/yBADQSPcdZs=
MIME-Version: 1.0
In-Reply-To: <6501.1280759131@localhost>
References: <AANLkTik7powjUaJ51bA_bgPVb03U-RVZay3NffHBYLzx@mail.gmail.com>
	<215375.1280753770@localhost>
	<AANLkTi=keL2rUzxdxgscTU9cQSNxOnAtGVuAwTq9Wfuq@mail.gmail.com>
	<6501.1280759131@localhost>
Date: Mon, 2 Aug 2010 23:02:01 +0800
Message-ID: <AANLkTik8DSLFeGqHspYjykt_vCF7SxupKSxKcB2LLRhj@mail.gmail.com>
Subject: Re: a Great Idea - include Kademlia networking protocol in kernel
From: hp fk <fkhp101@gmail.com>
To: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/2  <Valdis.Kletnieks@vt.edu>:
> On Mon, 02 Aug 2010 22:10:30 +0800, you said:
> Two problems with that:
>
> 1) There doesn't seem to be any push to get multiple HTTP-speaking
> programs (firefox, wget, yum, etc) to a 'consolidated' one - letting the
> kernel keep track of connections to userspace seems to work well
> there.  You need to explain what *exactly* the kernel will be doing
> to support this (in other words, have at least the start of an API
> and what the semantics are..)

 HTTP if more of an access protocol,the logical network is woven in
the web page controled by html, the network needed is formed and take
part in by tcp/ip protocol which usually lies in kernel.

Kademlia itself has the responsibility to weave the p2p network and
bring a node into the p2p network before access can be done.
