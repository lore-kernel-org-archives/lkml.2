Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0DTByz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 21:54:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51059 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab0DTByy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 21:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=PTkX6VMEBcTfSNaKI+yLbWrlPlvcLA9YC1RpCgvA0/9MiPD/l2AgNFPrlrmDHsOdAl
         TSu5EkohKyF4KHXzbGqJh96/QO5rixaF2oqMRwXTDUr2xwL/iu7NgjY7/b31WBqsmOvp
         mQA4h1BJgi+h+sBeZD1vMBPFZoXmI46MPgPxU=
MIME-Version: 1.0
In-Reply-To: <k2s363172901004182032zea2277b4s40e55ae436d2353e@mail.gmail.com>
References: <k2s363172901004182032zea2277b4s40e55ae436d2353e@mail.gmail.com>
Date: Tue, 20 Apr 2010 09:54:52 +0800
Message-ID: <k2w363172901004191854t72fa19fahdb93fa498b23fcf6@mail.gmail.com>
Subject: IPv4 NAT UDP Traversal issue
From: =?GB2312?B?t8nR1Q==?= <win847@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

       I have a question about Linux NAT, our Product is ADSL
Router(Linux Version is 2.6.22.15), and Now our customers requirment
is below:

       IPv4 Nat: UDP Traversal through NAT, must support STUN
(RFC3489)  the four ways: Full Cone¡¢Restricted Cone¡¢Port Restricted
Cone and Symmetric

       As I known, netfilter IPv4 NAT is belonged to Symmetric type.
and if want UDP Traversal through NAT, NAT Device can not be Port
Restricted Cone and Symmetric type if the other is Symmetric type.

       So my question is: Can iptable set the UDP NAT converted to
Full Cone or Restricted Cone type?

       we now set NAT use iptables below£º

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  anywhere             anywhere

       Thanks very much!

BR,
win847
