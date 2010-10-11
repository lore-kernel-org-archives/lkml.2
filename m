Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0JKTQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:16:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59352 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab0JKTQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:16:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eXLJHT+DV4DgiuJP/w4Ep6HHEUROm7Y45ZtbxSn8JKvpnbrtfToSgog5xj3CT8iALn
         FUSZb0a9C/njtrRPn5Llw9M7R6LmyexowTwz7t9BU4a7oTkxkJJJEyFFy9diAZWK285b
         8utSLMOgM6Csa7xh/fnP6JvLrdoUR8/zJSUFY=
MIME-Version: 1.0
In-Reply-To: <AANLkTinQQ0Y4TcRQdRhLgeBJTcvbRyiaxxHuSeh2F0Pp@mail.gmail.com>
References: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
	<1286811979.9645.5.camel@ayu>
	<AANLkTinQQ0Y4TcRQdRhLgeBJTcvbRyiaxxHuSeh2F0Pp@mail.gmail.com>
Date: Mon, 11 Oct 2010 22:16:10 +0300
Message-ID: <AANLkTikz0KMmE+H=1zwyrOXPzXzYFMj2S36JX3WkO3AH@mail.gmail.com>
Subject: Re: Horrible btrfs performance on cold cache
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Chester <somethingsome2000@gmail.com>
Cc: Calvin Walton <calvin.walton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 7:23 PM, Chester <somethingsome2000@gmail.com> wrote:
> I think I read/heard somewhere that snapshots can cause pretty bad
> fragmentation

But I'm not using snapshots.

-- 
Felipe Contreras
