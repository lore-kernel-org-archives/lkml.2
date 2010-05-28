Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab0E1DC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 23:02:58 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:37009 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab0E1DC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 23:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hJxPgazPxOnjE67CSa8h5zPwF9FPCYHXiMJr0r1cU/krZTxE3Isq4vyky8/15k8qNj
         znDqwwvBfE2y7rfuPKpnQJaG/yx7XHd8vtBzUiCWTgH9262LLQeDfTSoVcbKKs4pZEKJ
         LhnL2uik4FItv3aFrjOn9eHWae9RnRdQbaFjs=
MIME-Version: 1.0
Date: Thu, 27 May 2010 21:02:55 -0600
Message-ID: <AANLkTinUsKL0kqAjRG95xcrqjWPUlNn1TPD21wIJjShS@mail.gmail.com>
Subject: Question about SIOCGIFCONF
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why is SIOGICONF only instrumented to return a single interface lo for
example.  I noticed that ifconfig always uses /proc/net/dev but the
older SIOCGIFCONF ioctl seems to be busted.  Anyone have an
explanation or is this just how the shit is these days or is the
fucking thing broken (seems to be). ?

Jeff
