Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1DROGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:06:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49196 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1DROGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YRPFckA/LB9ngDlO21jJwsZEwKt2/jxlgme1Er48xQwvOQ5Ob74tqPqiXfR3eKIewT
         eyABmkmUrR8BTU1H3T7/eCNHfhvq3tfC4iDRkecS9NDwHTtMKW/5kJuLO5PoNmp4kE5O
         SYqbVYQ5QOoAexwhI/1GZ21pqjuFU4zx6kjeQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Sage Weil <sage@newdream.net>
Subject: Re: [Regression,bisected] 2.6.39-rc3 ceph client write hangs
Date: Mon, 18 Apr 2011 16:05:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc3; KDE/4.4.5; i686; ; )
Cc: Jim Schutt <jaschut@sandia.gov>, dchinner@redhat.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <4DA879CA.8060305@sandia.gov> <201104172017.15090.maciej.rutecki@gmail.com> <Pine.LNX.4.64.1104172249540.18433@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.1104172249540.18433@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104181605.54981.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 18 kwietnia 2011 o 07:52:40 Sage Weil wrote:
> This was a simple s/igrab/ihold/ fix.  See
> 
> 283a85dc6e670083adb1e5437bd93d163f4f801a
> 
> in the for-linus branch of ceph-client.git.  I'll push to Linus in the
> next few days.
> 

Thanks, closing.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
