Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2A3TEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:04:00 -0500
Received: from mail-we0-f194.google.com ([74.125.82.194]:65060 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2A3TD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:03:59 -0500
MIME-Version: 1.0
Date: Mon, 30 Jan 2012 20:03:58 +0100
Message-ID: <CAPNxggbGr+UnAX6nwt5V4-BSRBLEBq5HvAuP28kxckcJ1sJEtQ@mail.gmail.com>
Subject: An alternative for tasklist_lock in a module?
From: "Arokux B." <arokux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(for learning purposes) I would like to iterate through all the tasks
in a module and output different information about them. For this task
I need to lock the list of all tasks (need I?). I've seen some example
in the kernel code which lock tasklist_lock. However this symbol
cannot be used by modules. Its export was removed by
c59923a15c12d2b3597af913bf234a0ef264a38b commit.

Is there any other way I can lock the list of tasks then?

Thanks
