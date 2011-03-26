Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1CZQ7f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:59:35 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49351 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1CZQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UMsS7CYUMX4N/CN+Fc/5pV/Yf9ECxCx8bck/INtKP3jBJujrrLV0QJ1/qrm3C4YkjN
         H7MHe9D79eUoGlPVwHRBOlQamvOigajFVNfkq9CqqvvJrYL+DqL0NLxVhOZnPc0iRwC9
         K/26er54tB++pxBWtf3APdRa0fWQPktxiLozw=
MIME-Version: 1.0
Date: Sat, 26 Mar 2011 17:59:33 +0100
Message-ID: <AANLkTinMY7BhPL_WAjnZr-zBOEQTbABvCVBmg1AowtON@mail.gmail.com>
Subject: Module.symvers not ignored at all?
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

why is "Module.symvers" only ignored in the root directory
but not in the others? If i rebuild separate modules, i see some
of these files with "git status".

Thanks,
Ralf
