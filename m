Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1ALQUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:20:43 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33755 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1ALQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Ihml9vmT42vXOsVXE3bScW6mAlriQg7XHgnARTJPdU/339Ch3XbZG1ps0UhZiiZPcq
         JKo3tri3LXtLE084392+EL/hFrkthgRfdX8OuuoojlG2n2gnfvEq3T0vXBqsd7b69J26
         8hBVNUB+njKLGt9xa8ukkKadS7vc8hUcTpWXU=
MIME-Version: 1.0
Date: Wed, 12 Jan 2011 14:20:40 -0200
Message-ID: <AANLkTi=jEeSCN+ahkfTqN8655UhL-dtYfi9EfQqHKy98@mail.gmail.com>
Subject: netns physical interface moving
From: Renato Westphal <renatowestphal@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would be very nice if someone could help me on this questions:

1) I've read that using Kernel >2.6.35 it is possible to move physical
interfaces across network namespaces. I would like to port this
feature to Kernel 2.6.32. Does anyone has any idea on how difficult it
would be? The related commits?

2) How can one communicate a Serial interface on the initial network
namespace to another interface (ethernet) on another namespace? I've
tried to do that using bridges and virtual ethernet pairs but since
bridges rely on ethernet frame's mac addresses it is not possible to
create the interface between the serial interface and the bridge.

Regards,
Renato.

--
Renato Westphal
