Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1CYXdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:33:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63470 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1CYXdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dS/IKdEyGQA3ORzxNY4WdzshvIFSBwdl5fPfsD8g3OOHkUDU5UK6gbjzKPmcW6MBf0
         iY32nSWSdkRV24gKr3PYENIup2Re7VxLhn1pzHWeK8nNFnC9E3r7ab6qw96L45e4PRfn
         bi43u9jfrxBAKiOXv7ORok+Us/UsWPqI3lqs0=
MIME-Version: 1.0
Date: Fri, 25 Mar 2011 19:33:11 -0400
Message-ID: <AANLkTinR7-uaK9_WB=nqD+SCBPCkRXJGA5QdURe7ZK5r@mail.gmail.com>
Subject: Ext3: Why journal is better than ordered when data needs to be read
 from and written to disk at the same time
From: Jidong Xiao <jidong.xiao@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see many literatures mentioned this, but I have never seen any one
explains it in detail.(Although this link exposed the original story:
http://lkml.indiana.edu/hypermail//linux/kernel/0107.1/0364.html)

"Journal mode: This mode is the slowest except when data needs to be
read from and written to disk at the same time where it outperform all
others mode."

Since this is counter-intuitive, I believe many people are not aware
about the root cause. Can any one kindly explain it so as to make it
more clear? Thank you!

Regards
Jidong
