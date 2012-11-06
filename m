Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab2KFLeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:34:24 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61163 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2KFLeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:34:23 -0500
MIME-Version: 1.0
Date: Tue, 6 Nov 2012 06:34:22 -0500
Message-ID: <CAHdPZaPwvk2baGRng7kUnfT5ZcRrAB82_AjEakxBr5ZkvVfNqA@mail.gmail.com>
Subject: recvfrom a large packet
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if i do a recvfrom (sk, buf, 10000, 0, &addr, &len), shall i recv all the data
i mean the 10000 bytes?

since fragmentation happen in the ip layer and assembled happen in the
ip layer it doesnt matter for the upper layer about the packet size.


i wrote a test code and it seems to be working.

is there any problem will come if i turn on firewall.

any ideas?
