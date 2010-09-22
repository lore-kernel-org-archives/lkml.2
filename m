Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0IVVKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:10:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62048 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0IVVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:10:16 -0400
Message-ID: <4C9A70B2.3090101@alessandroguido.name>
Date: Wed, 22 Sep 2010 23:10:10 +0200
From: Alessandro Guido <ag@alessandroguido.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100908 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dri-devel@lists.freedesktop.org
Subject: idr_remove called for id=0 which is not allocated
Content-Type: multipart/mixed;
 boundary="------------050505080507020007010103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050505080507020007010103
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I have this traces in my logs (full dmesg attached).

idr_remove called for id=0 which is not allocated.
Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
Call Trace:
  [<c1379e16>] ? printk+0x18/0x1a
  [<c113b8f3>] idr_remove+0x73/0x1c0
  [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
  [<c11b8f6e>] drm_mode_destroy+0xe/0x20
  [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
  [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
  [<c103800b>] ? queue_delayed_work+0x1b/0x30
  [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
  [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
  [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
  [<c1068071>] ? filemap_fault+0x81/0x3c0
  [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
  [<c107bedf>] ? handle_mm_fault+0x13f/0x670
  [<c11aff10>] ? drm_ioctl+0x0/0x4b0
  [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
  [<c101a14c>] ? do_page_fault+0x17c/0x3c0
  [<c108fc6d>] ? vfs_write+0xfd/0x140
  [<c108f1c0>] ? do_sync_write+0x0/0xe0
  [<c109ceb9>] sys_ioctl+0x39/0x60
  [<c1002b90>] sysenter_do_call+0x12/0x26
idr_remove called for id=0 which is not allocated.
Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
Call Trace:
  [<c1379e16>] ? printk+0x18/0x1a
  [<c113b8f3>] idr_remove+0x73/0x1c0
  [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
  [<c11b8f6e>] drm_mode_destroy+0xe/0x20
  [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
  [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
  [<c103800b>] ? queue_delayed_work+0x1b/0x30
  [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
  [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
  [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
  [<c1068071>] ? filemap_fault+0x81/0x3c0
  [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
  [<c107bedf>] ? handle_mm_fault+0x13f/0x670
  [<c11aff10>] ? drm_ioctl+0x0/0x4b0
  [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
  [<c101a14c>] ? do_page_fault+0x17c/0x3c0
  [<c108fc6d>] ? vfs_write+0xfd/0x140
  [<c108f1c0>] ? do_sync_write+0x0/0xe0
  [<c109ceb9>] sys_ioctl+0x39/0x60
  [<c1002b90>] sysenter_do_call+0x12/0x26
[drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 1
idr_remove called for id=0 which is not allocated.
Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
Call Trace:
  [<c1379e16>] ? printk+0x18/0x1a
  [<c113b8f3>] idr_remove+0x73/0x1c0
  [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
  [<c11b8f6e>] drm_mode_destroy+0xe/0x20
  [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
  [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
  [<c103800b>] ? queue_delayed_work+0x1b/0x30
  [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
  [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
  [<c12ed55a>] ? __kfree_skb+0x3a/0x90
  [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
  [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
  [<c108f344>] ? do_sync_read+0xa4/0xe0
  [<c107bfa1>] ? handle_mm_fault+0x201/0x670
  [<c11aff10>] ? drm_ioctl+0x0/0x4b0
  [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
  [<c101a14c>] ? do_page_fault+0x17c/0x3c0
  [<c108fe96>] ? vfs_read+0xf6/0x140
  [<c109ceb9>] sys_ioctl+0x39/0x60
  [<c1002b90>] sysenter_do_call+0x12/0x26
idr_remove called for id=0 which is not allocated.
Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
Call Trace:
  [<c1379e16>] ? printk+0x18/0x1a
  [<c113b8f3>] idr_remove+0x73/0x1c0
  [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
  [<c11b8f6e>] drm_mode_destroy+0xe/0x20
  [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
  [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
  [<c103800b>] ? queue_delayed_work+0x1b/0x30
  [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
  [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
  [<c12ed55a>] ? __kfree_skb+0x3a/0x90
  [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
  [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
  [<c108f344>] ? do_sync_read+0xa4/0xe0
  [<c113f56b>] ? rb_insert_color+0xdb/0x110
  [<c11aff10>] ? drm_ioctl+0x0/0x4b0
  [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
  [<c1040ad3>] ? hrtimer_start+0x23/0x30
  [<c108fe96>] ? vfs_read+0xf6/0x140
  [<c109ceb9>] sys_ioctl+0x39/0x60
  [<c1002b90>] sysenter_do_call+0x12/0x26
idr_remove called for id=0 which is not allocated.
Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
Call Trace:
  [<c1379e16>] ? printk+0x18/0x1a
  [<c113b8f3>] idr_remove+0x73/0x1c0
  [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
  [<c11b8f6e>] drm_mode_destroy+0xe/0x20
  [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
  [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
  [<c103800b>] ? queue_delayed_work+0x1b/0x30
  [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
  [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
  [<c12ed55a>] ? __kfree_skb+0x3a/0x90
  [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
  [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
  [<c108f344>] ? do_sync_read+0xa4/0xe0
  [<c113f56b>] ? rb_insert_color+0xdb/0x110
  [<c11aff10>] ? drm_ioctl+0x0/0x4b0
  [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
  [<c1040ad3>] ? hrtimer_start+0x23/0x30
  [<c108fe96>] ? vfs_read+0xf6/0x140
  [<c109ceb9>] sys_ioctl+0x39/0x60
  [<c1002b90>] sysenter_do_call+0x12/0x26
EXT4-fs (sda3): re-mounted. Opts: nobarrier,commit=0
EXT4-fs (sda4): re-mounted. Opts: commit=0
idr_remove called for id=0 which is not allocated.
Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
Call Trace:
  [<c1379e16>] ? printk+0x18/0x1a
  [<c113b8f3>] idr_remove+0x73/0x1c0
  [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
  [<c11b8f6e>] drm_mode_destroy+0xe/0x20
  [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
  [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
  [<c103800b>] ? queue_delayed_work+0x1b/0x30
  [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
  [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
  [<c12ed55a>] ? __kfree_skb+0x3a/0x90
  [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
  [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
  [<c108f344>] ? do_sync_read+0xa4/0xe0
  [<c113f56b>] ? rb_insert_color+0xdb/0x110
  [<c11aff10>] ? drm_ioctl+0x0/0x4b0
  [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
  [<c1040ad3>] ? hrtimer_start+0x23/0x30
  [<c108fe96>] ? vfs_read+0xf6/0x140
  [<c109ceb9>] sys_ioctl+0x39/0x60
  [<c1002b90>] sysenter_do_call+0x12/0x26
idr_remove called for id=0 which is not allocated.
Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
Call Trace:
  [<c1379e16>] ? printk+0x18/0x1a
  [<c113b8f3>] idr_remove+0x73/0x1c0
  [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
  [<c11b8f6e>] drm_mode_destroy+0xe/0x20
  [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
  [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
  [<c103800b>] ? queue_delayed_work+0x1b/0x30
  [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
  [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
  [<c12ed55a>] ? __kfree_skb+0x3a/0x90
  [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
  [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
  [<c108f344>] ? do_sync_read+0xa4/0xe0
  [<c113f56b>] ? rb_insert_color+0xdb/0x110
  [<c11aff10>] ? drm_ioctl+0x0/0x4b0
  [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
  [<c1040ad3>] ? hrtimer_start+0x23/0x30
  [<c108fe96>] ? vfs_read+0xf6/0x140
  [<c109ceb9>] sys_ioctl+0x39/0x60
  [<c1002b90>] sysenter_do_call+0x12/0x26
idr_remove called for id=0 which is not allocated.
Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
Call Trace:
  [<c1379e16>] ? printk+0x18/0x1a
  [<c113b8f3>] idr_remove+0x73/0x1c0
  [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
  [<c11b8f6e>] drm_mode_destroy+0xe/0x20
  [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
  [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
  [<c103800b>] ? queue_delayed_work+0x1b/0x30
  [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
  [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
  [<c12ed55a>] ? __kfree_skb+0x3a/0x90
  [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
  [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
  [<c108f344>] ? do_sync_read+0xa4/0xe0
  [<c113f56b>] ? rb_insert_color+0xdb/0x110
  [<c11aff10>] ? drm_ioctl+0x0/0x4b0
  [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
  [<c1040ad3>] ? hrtimer_start+0x23/0x30
  [<c108fe96>] ? vfs_read+0xf6/0x140
  [<c109ceb9>] sys_ioctl+0x39/0x60
  [<c1002b90>] sysenter_do_call+0x12/0x26
idr_remove called for id=0 which is not allocated.
Pid: 1136, comm: Xorg Not tainted 2.6.36-rc5-49-gc79bd89 #1
Call Trace:
  [<c1379e16>] ? printk+0x18/0x1a
  [<c113b8f3>] idr_remove+0x73/0x1c0
  [<c11b8d6f>] drm_mode_object_put+0x2f/0x50
  [<c11b8f6e>] drm_mode_destroy+0xe/0x20
  [<c11eb24b>] nouveau_connector_get_modes+0x2b/0x390
  [<c1185b6f>] ? acpi_lid_open+0x22/0x3c
  [<c103800b>] ? queue_delayed_work+0x1b/0x30
  [<c11abf34>] drm_helper_probe_single_connector_modes+0xc4/0x360
  [<c11bb6a7>] drm_mode_getconnector+0x2a7/0x350
  [<c12ed55a>] ? __kfree_skb+0x3a/0x90
  [<c11b00d2>] drm_ioctl+0x1c2/0x4b0
  [<c11bb400>] ? drm_mode_getconnector+0x0/0x350
  [<c108f344>] ? do_sync_read+0xa4/0xe0
  [<c113f56b>] ? rb_insert_color+0xdb/0x110
  [<c11aff10>] ? drm_ioctl+0x0/0x4b0
  [<c109c90d>] do_vfs_ioctl+0x7d/0x5f0
  [<c1040ad3>] ? hrtimer_start+0x23/0x30
  [<c108fe96>] ? vfs_read+0xf6/0x140
  [<c109ceb9>] sys_ioctl+0x39/0x60
  [<c1002b90>] sysenter_do_call+0x12/0x26

--------------050505080507020007010103
Content-Type: application/x-gzip;
 name="dmesg.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg.gz"

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
pbuV7la6W+lupbv7dfc/95neB3qGAAA=
--------------050505080507020007010103--
