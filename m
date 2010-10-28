Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0J1I7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 04:59:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64688 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0J1I7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 04:59:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YD33x19SYUDXaYrQzHP6QB5EqMk2iwp+NQCk0NzWGDeMe0XY96g9sEiTDYqn/9XJst
         W0Zqf+OXdsCvxIGI/urIKqlNOoTqHu8UOVtnHlgc8+Ra9BnMjokcvSK9XoLFgk3PR5kZ
         yQD2NmqqojHPPDomlRG8ZgXSayaYNE9b4oyuk=
MIME-Version: 1.0
In-Reply-To: <AANLkTinqG_G2pevoYJyiHiBda1ZZS-53Uqz9WEspbMOy@mail.gmail.com>
References: <1288213257.17571.25.camel@localhost.localdomain>
	<1288213557.17571.28.camel@localhost.localdomain>
	<AANLkTinqG_G2pevoYJyiHiBda1ZZS-53Uqz9WEspbMOy@mail.gmail.com>
Date: Thu, 28 Oct 2010 09:59:39 +0100
Message-ID: <AANLkTikgiFFCTK7aBChwt0vj3BGJpM2zO44-nDDQeHaM@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] vhost: Reduce TX used buffer signal for performance
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: "mst@redhat.com" <mst@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 9:57 AM, Stefan Hajnoczi <stefanha@gmail.com> wrote:
Just read the patch 1/1 discussion and it looks like you're already on
it.  Sorry for the noise.

Stefan
