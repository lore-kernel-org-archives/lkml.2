Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0DFOhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:37:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57166 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0DFOhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=nE46jjz3OQ6GbFFjX+6d09LSnbFuWsP2rzxHcXJ6zPP1Pu1M1Thi0IxMs1nATZycct
         qFRN6aHTZFuYK56WksRzgcSnk9Kszu8kqkKi8+LB8TKlRfox4CW1FoKYaktziPfkExU4
         rLU8hZEquGkM61Hs4fW2KrE4nujQKCNB6pUBA=
MIME-Version: 1.0
Date: Tue, 6 Apr 2010 22:37:46 +0800
Message-ID: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
Subject: why choose 896MB to the start point of ZONE_HIGHMEM
From: hayfeng Lee <teklife.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, linux-kernel@zh-kernel.org,
       kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,every one.
I have a question:
Why does linux choose 896MB to do a start point of ZONE_HIGHMEM and
the end point of ZONE_NORMAL. Just for experience?
What is the advantages?
